# このコードをコピペしてrubyファイルに貼り付け、そのファイルをirbでrequireして実行しましょう。
# 例
# irb
# require ‘/Users/shibatadaiki/work_shiba/full_stack/sample.rb’
# （↑のパスは、自動販売機ファイルが入っているパスを指定する）
# 初期設定（自動販売機インスタンスを作成して、vmという変数に代入する）
# vm = VendingMachine.new
# 作成した自動販売機に100円を入れる
# vm.slot_money (100)
# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_slot_money
# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money

require './drink.rb'
require './inventory.rb'

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY=[10, 50, 100, 500, 1000].freeze

  # ステップ２　ジュースの管理
  # 値段と名前の属性からなるジュースを１種類格納できる。
  # ステップ４　機能拡張
  # ジュースを3種類管理できるようにする。

  #ITEMS_PRICE={cola: 120}.freeze

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money=0

    # ステップ２　ジュースの管理
    # 初期状態で、コーラ（値段:120円、名前”コーラ”）を5本格納している。
    # 売り上げ金額の初期化
    @stock=Inventory.new
    @stock.add( Drink.new(Drink::Kind::COLA), 5 )

  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    # 自動販売機にお金を入れる

    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    if( MONEY.include?(money) )
      @slot_money += money
      true;
    else
      false;
    end
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    ret=@slot_money;
    puts "釣り銭#{@slot_money}円"

    # 自動販売機に入っているお金を0円に戻す
    @slot_money=0
    ret
  end

  #ステップ２　ジュースの管理
  #格納されているジュースの情報（値段と名前と在庫）を取得できる。
  def stock_info
    @stock.to_s
  end

  #ステップ３　購入
  # 投入金額、在庫の点で、コーラが購入できるかどうかを取得できる。
  # 投入金額が足りない場合もしくは在庫がない場合、購入操作を行っても何もしない。
  def can_buy?(item)
    a = @stock.can_buy?(item, current_slot_money)
    if(a.class==Array)
      true
    else
      false
    end
  end

  #ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、ジュースの在庫を減らし、売り上げ金額を増やす
  def purchase(item)
    if can_buy?(item)
      @slot_money -= Drink::price(item)
      return (@stock.pull_one(item)>0 ? true : false)
    else
      false
    end
  end

  #現在の売上金額を取得できる。
  def sales
    @stock.current_sales
  end

  #ステップ４　機能拡張
  #払い戻し操作では現在の投入金額からジュース購入金額を引いた釣り銭を出力する。
  def refund(item)
    purchase(item) ? @slot_money : false
  end

  # 投入金額、在庫の点で購入可能なドリンクのリストを取得できる。
  def available_items
    @stock.available_items(current_slot_money)
  end

  # ステップ５　釣り銭と売り上げ管理
=begin
  ジュース値段以上の投入金額が投入されている条件下で購入操作を行うと、釣り銭（投入金額とジュース値段の差分）を出力する。
  ジュースと投入金額が同じ場合、つまり、釣り銭0円の場合も、釣り銭0円と出力する。
  釣り銭の硬貨の種類は考慮しなくてよい。
=end

end
