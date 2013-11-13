class Event
  attr_accessor :item, :type, :count

  def initialize(item)
    @item = item
    @count = 1

    if item.is_a? Map
      @type = :map
    elsif item.is_a? MapComment
      @type = :map_comment
    elsif item.is_a? Vote
      @type = :vote
    else
      @type = :unknown
    end
  end

  def user
    if ([:map_comment, :vote].include? @type) && !aggregate?
      @item.user
    else
      nil
    end
  end

  def map
    if @type == :map
      @item
    elsif ([:map_comment, :vote].include? @type)
      @item.map
    else
      nil
    end
  end

  def increment
    @count += 1
  end

  def aggregate?
    @count > 1
  end

  def to_s
    if aggregate?
      case @type
      when :map_comment
        "#{@count} users commented on #{map.name}"
      when :vote
        "#{@count} users voted on #{map.name}"
      else
        "This should not be aggreagted"
      end
    else
      case @type
      when :map
        "#{map.name} was added to the map list"
      when :map_comment
        "#{user.nickname} commented on #{map.name}"
      when :vote
        "#{user.nickname} voted on #{map.name}"
      else
        "Unkown event"
      end
    end
  end

  def self.build_list items
    current_map = nil
    list_buffer = []
    last_type = {}

    items.each do |i|
      e = Event.new(i)

      if e.map == current_map
        if last_type[e.type].nil?
          last_type[e.type] = e
        else
          last_type[e.type].increment
        end
      else
        list_buffer += last_type.values
        last_type = {}
        last_type[e.type] = e
        current_map = e.map
      end
    end

    list_buffer += last_type.values

    return list_buffer
  end

end
