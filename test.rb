    i = 0
    result = []
    while i < 10
      i += 1
      next if (i % 2) == 0
      result << i
    end
    puts result