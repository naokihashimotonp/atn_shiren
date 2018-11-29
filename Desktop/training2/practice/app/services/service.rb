class Service
  validates :card, format: { with: /\A[HSDC]{1}([1-9]{1}|1[0-3]{1})[ ]{1}[HSDC]{1}([1-9]{1}|1[0-3]{1})[ ]{1}[HSDC]{1}([1-9]{1}|1[0-3]{1})[ ]{1}[HSDC]{1}([1-9]{1}|1[0-3]{1})[ ]{1}[HSDC]{1}([1-9]{1}|1[0-3]{1})\z/ }

  def cards_receiver(params)
    card = params[:card]
  end

  # webアプリの役判定のロジック

  def web_app_judge(params)
    # cards         = Card.create(card: params[:card])
    splited_cards = split(card)
    numbers       = numbers(splited_cards)
    suits         = suits(splited_cards)
    porker_hand   = porker_hands(numbers, suits, splited_cards)
    return porker_hand
  end


  # APIのレスポンスの中身を作るロジック
  def create_response(params)

    # カードの情報を受け取る
    cards = Card.create(card: params[:cards])
    # paramsとして渡されたjsonから不要な値を取り除いたarrayを変数に入れる。
    sophisticated_cards = cards.card.delete("\",[,]")
    # カードを1枚ずつに分類する。
    cards_array = sophisticated_cards.split
    # 最初の5枚を1つ目のカード群として取り出し変数に入れる。
    splited_cards1 = cards_array.take(5)
    # 6枚目〜10枚目を2つ目のカード群として取り出し変数に入れる。
    splited_cards2 = cards_array.drop(5).take(5)
    # 11枚目〜15枚目を3つ目のカード群として取り出し変数に入れる。
    splited_cards3 = cards_array.drop(10)

    # 各カード群を数字のみに分ける。
    numbers1 = numbers(splited_cards1)
    numbers2 = numbers(splited_cards2)
    numbers3 = numbers(splited_cards3)

    # 各カード群を文字のみに分ける。
    suits1 = suits(splited_cards1)
    suits2 = suits(splited_cards2)
    suits3 = suits(splited_cards3)

    # 各カード群について役判定を行い、変数に入れる。
    porker_hand1 = porker_hands(numbers1, suits1, splited_cards1)
    porker_hand2 = porker_hands(numbers2, suits2, splited_cards2)
    porker_hand3 = porker_hands(numbers3, suits3, splited_cards3)


    # 各カード群のスコアを変数に入れる。
    score1 = score?(porker_hand1)
    score2 = score?(porker_hand2)
    score3 = score?(porker_hand3)


    # スコアを用いて役を比較し、スコアが最大であるカード群にtrueを入れ、最大でないカード群にfalseを入れる。
    best_hand = best?(score1, score2, score3)

    # カード群ごとに役や最も強い役であるか否かの結果を入れる。
    result = {
      "cards1" => {
        "cards" => splited_cards1,
        "hand"  => porker_hand1,
        "best"  => best_hand[0]
      },
      "cards2" => {
        "cards" => splited_cards2,
        "hand"  => porker_hand2,
        "best"  => best_hand[1]

      },
      "cards3" => {
        "cards" => splited_cards3,
        "hand"  => porker_hand3,
        "best"  => best_hand[2]

      }
    }

    return result
  end

  def split(cards)
    cards.split(" ")
    # @splited_card = @splited_card("")
  end

  def numbers(splited_cards)
    numbers = splited_cards.map {|card|
      card.gsub(/[HSDC]/, "").to_i
    }
    numbers = numbers.sort
    return numbers
  end

  def suits(splited_cards)
    suits = splited_cards.map {|card|
      card.gsub(/[\d]/, "")
    }
    suits = suits.sort {|a, b| a <=> b}
    return suits
  end

  def straight?(numbers)
    #繰り返し処理のための配列を用意
    array_for_roop = [0, 1, 2, 3, 4]
    #ストレートであるかをチェックする配列を用意
    straight_check = []

    array_for_roop.each do |n|
      # 配列のn番目の要素と配列の(n+1)番目の差が1である→配列の中身は連続している
      if numbers[n] + 1 == numbers[n + 1]
        straight_check.push("flag_check")
      end
    end

    # 隣り合う2つの値の差が、4つとも1であればストレートである
    if straight_check.count("flag_check") == 4
      straight_flag = true
    end
    return straight_flag
  end

  def flush?(suits)
    # 同じスートが5枚⇔ソートした上でスートの１番目と５番目が同じ
    if suits[0] == suits[4]
      flush_flag = true
    end
    return flush_flag
  end

  def four_of_a_kind?(numbers)

    # 最後のみ同じ数値でない場合と最初のみ同じ数値でない場合
    if numbers[0] == numbers[1] and numbers[1] == numbers[2] and numbers[2] == numbers[3]
      four_of_a_kind_flag = true
    elsif numbers[1] == numbers[2] and numbers[2] == numbers[3] and numbers[3] == numbers[4]
      four_of_a_kind_flag = true
    end
    return four_of_a_kind_flag
  end

  def full_house?(numbers)
    # 最初の3つが同じ∧後ろの2つが同じ場合と最初の2つが同じ∧最後の3つが同じ場合
    if numbers[0] == numbers[1] and numbers[1] == numbers[2]
      if numbers[3] == numbers[4]
        full_house_flag = true
      end
    elsif numbers[2] == numbers[3] and numbers[3] == numbers[4]
      if numbers[0] == numbers[1]
        full_house_flag = true
      end
    end
    return full_house_flag
  end


  def three_of_a_kind?(numbers)
    # 最初の3つが同じ、真ん中3つが同じ、最後の3つが同じの3通り
    if numbers[0] == numbers[1] and numbers[1] == numbers[2] and numbers[3] != numbers[4]
      three_of_a_kind_flag = true
    elsif numbers[1] == numbers[2] and numbers[2] == numbers[3] and numbers[3] == numbers[4]
      three_of_a_kind_flag = true
    elsif numbers[2] == numbers[3] and numbers[3] == numbers[4] and numbers[0] != numbers[1]
      three_of_a_kind_flag = true
    end
    return three_of_a_kind_flag
  end

  def two_pairs?(numbers)
    # 最後のみペアでない場合、真ん中のみペアでない場合、最初のみペアでない場合
    if numbers[0] == numbers[1] and numbers[2] == numbers[3]
      two_pairs_flag = true
    elsif numbers[0] == numbers[1] and numbers[3] == numbers[4]
      two_pairs_flag = true
    elsif numbers[1] == numbers[2] and numbers[3] == numbers[4]
      two_pairs_flag = true
    end
    return two_pairs_flag
  end

  def one_pair?(numbers)
    # 最初の2つがペアの場合、次の2つがペアの場合…の4通り
    if numbers[0] == numbers[1]
      one_pair_flag = true
    elsif numbers[1] == numbers[2]
      one_pair_flag = true
    elsif numbers[2] == numbers[3]
      one_pair_flag = true
    elsif numbers[3] == numbers[4]
      one_pair_flag = true
    end
    return one_pair_flag
  end

  def porker_hands(numbers, suits, splited_cards)

    straight_flag        = straight?(numbers)
    flush_flag           = flush?(suits)
    four_of_a_kind_flag  = four_of_a_kind?(numbers)
    full_house_flag      = full_house?(numbers)
    three_of_a_kind_flag = three_of_a_kind?(numbers)
    two_pairs_flag       = two_pairs?(numbers)
    one_pair_flag        = one_pair?(numbers)
    not_unique_flag      = uniq?(splited_cards)

    if not_unique_flag
      return "カードの重複があります。重複がないようにご入力ください。"
    elsif straight_flag and flush_flag
      # flash[:notice] = "ストレートフラッシュ"
      return "straight_flush"
    elsif four_of_a_kind_flag
      # flash[:notice] = "フォー・オブ・ア・カインド"
      return "four_of_a_kind"
    elsif full_house_flag
      # flash[:notice] = "フルハウス"
      return "full_house"
    elsif flush_flag
      # flash[:notice] = "フラッシュ"
      return "flush"
    elsif straight_flag
      # flash[:notice] = "ストレート"
      return "straight"
    elsif three_of_a_kind_flag
      # flash[:notice] = "スリー・オブ・ア・カインド"
      return "three_of_a_kind"
    elsif two_pairs_flag
      # flash[:notice] = "ツーペア"
      return "two_pairs"
    elsif one_pair_flag
      # flash[:notice] = "ワンペア"
      return "one_pair"
    else
      # flash[:notice] = "ハイカード"
      return "high_card"
    end

  end

  def score?(hand)
    if hand == "straight"
      return score = 9
    elsif hand == "four_of_a_kind"
      return score = 8
    elsif hand == "full_house"
      return score = 7
    elsif hand == "flush"
      return score = 6
    elsif hand == "straight"
      return score = 5
    elsif hand == "three_of_a_kind"
      return score = 4
    elsif hand == "two_pairs"
      return score = 3
    elsif hand == "one_pair"
      return score = 2
    elsif hand == "high_card"
      return score = 1
    end

    return score
  end


  def best?(score1, score2, score3)
    best_hand = []
    if score1 < score2 and score2 < score3
      return best_hand[0] = false, best_hand[1] = false, best_hand[2] = true
    elsif score2 < score3 and score3 < score1
      return best_hand[0] = true, best_hand[1] = false, best_hand[2] = false
    elsif score3 < score1 and score1 < score2
      return best_hand[0] = false, best_hand[1] = true, best_hand[2] = false
    end
  end

  def uniq?(splited_cards)
    #   重複がある場合
    splited_cards = splited_cards.uniq
    if splited_cards.length != 5
      return true
    end
  end

end
