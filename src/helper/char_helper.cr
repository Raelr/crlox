module CrLox::Helper
  def alpha_neumeric?(char : Char) : Bool
    alpha?(char) || digit?(char)
  end

  def alpha?(char : Char) : Bool
    (char >= 'a' && char <= 'z') ||
      (char >= 'A' && char <= 'Z') ||
      char == '_'
  end

  def digit?(char : Char) : Bool
    char >= '0' && char <= '9'
  end
end
