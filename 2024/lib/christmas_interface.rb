RESET = "\e[0m"
RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"

def format(result)
  result_length = result.to_s.length
  total_length = 17
  raise "Le résultat est trop long" if result_length > total_length

  necessary_whitespaces = total_length - result_length
  "#{" " * necessary_whitespaces.ceildiv(2)}#{result}#{" " * necessary_whitespaces.div(2)}"
end

def display_results(first_result, second_result = nil)
  puts <<~ASCII
    # .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
    # .     #{YELLOW}*#{RESET}                                                                                   .      .    .
    # .#{GREEN}    /.\           #{RESET}#{RED}              #{RESET}#{GREEN} __            #{RESET}#{GREEN} __             __     #{RESET}#{RED}  __        #{RESET}        _\\/  \\/_    .
    # .#{GREEN}   /..'\\        #{RESET} #{RED}        ____  #{RESET}#{GREEN}/ /_    #{RESET}#{RED} ____  #{RESET}#{GREEN}/ /_     #{RESET}#{RED}____ #{RESET}#{GREEN} / /_    #{RESET}#{RED} / /        #{RESET}         _\\/\\/_     .
    # .#{GREEN}   /'.'\\         #{RESET}#{RED}       / __ \\#{RESET}#{GREEN}/ __ \\#{RESET}#{RED}   / __ \\#{RESET}#{GREEN}/ __ \\#{RESET}#{RED}   / __ \\#{RESET}#{GREEN}/ __ \\   #{RESET}#{RED}/ /   #{RESET}           _\\_\\_\\/\\/_/_/_ .
    # .#{GREEN}  /.''.'\\       #{RESET} #{RED}      / /_/ /#{RESET}#{GREEN} / / /  #{RESET}#{RED}/ /_/ /#{RESET}#{GREEN} / / /  #{RESET}#{RED}/ /_/ /#{RESET}#{GREEN} / / /  #{RESET}#{RED}/_/         #{RESET}       / /_/\\/\\_\\ \\  .
    # .#{GREEN}  /.'.'.\\       #{RESET} #{RED}      \\____/#{RESET}#{GREEN}_/ /_/ #{RESET}#{RED}  \\____/#{RESET}#{GREEN}_/ /_/   #{RESET}#{RED}\\____/#{RESET}#{GREEN}_/ /_/  #{RESET}#{RED}(_)      #{RESET}              _/\\/\\_     .
    # .#{GREEN} /'.''.'.\\  #{RESET}                                                                              /\\  /\\     .
    # .#{GREEN} ^^^[_]^^^  #{RESET}                                                                             '      '    .
    # .                            __________________________________________                               .
    # .                           |                                          |                              .
    # .                           |   Today's First Result :#{YELLOW}#{format(first_result)}#{RESET}|                              .
    # .                           |__________________________________________|                              .
    # .                                                                                                     .
    # .                            __________________________________________                               .
    # .                           |                                          |                              .
    # .                           |   Today's Second Result:#{YELLOW}#{format(second_result)}#{RESET}|                              .
    # .                           |__________________________________________|                              .
    # .                                                                                                     .
    # .                                             #{RESET}#{RED}      __         _      __                         #{RESET}#{GREEN} __  #{RESET}.
    # .#{RED}     ____ _____   #{RESET}#{GREEN}  _________ __   _____     #{RESET}#{RED}_____/ /_  _____(_)____/ /_____ ___  ____ ______   #{RESET}#{GREEN}/ /  #{RESET}.
    # .#{RED}    / __ `/ __ \\ #{RESET}#{GREEN}  / ___/ __ `/ | / / _ \\  #{RESET}#{RED} / ___/ __ \\/ ___/ / ___/ __/ __ `__ \\/ __ `/ ___/  #{RESET}#{GREEN}/ /   #{RESET}.
    # .#{RED}   / /_/ / /_/ / #{RESET}#{GREEN} (__  ) /_/ /| |/ /  __/  #{RESET}#{RED}/ /__/ / / / /  / (__  ) /_/ / / / / / /_/ (__  )  #{RESET}#{GREEN}/_/    #{RESET}.
    # .#{RED}   \\__, /\\____/ #{RESET}#{GREEN} /____/\\__,_/ |___/\\___/  #{RESET}#{RED} \\___/_/ /_/_/  /_/____/\\__/_/ /_/ /_/\\__,_/____/  #{RESET}#{GREEN}(_)     #{RESET}.
    # .#{RED}  /____/                                                                                             #{RESET}.
    # .:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:.
  ASCII
end
