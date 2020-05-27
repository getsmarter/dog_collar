# Some monkeypatched helpers used in specs instead of bringing in something
# like active support
class Hash
  def stringify_keys
    transform_keys(&:to_s)
  end
end
