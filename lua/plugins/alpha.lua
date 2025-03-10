return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⡀⢀⠀⡀⢀⠀⡀⢀⠀⡀⢀⠀⡀⢀⠀⡀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠄⡐⠀⣀⣤⣶⣷⡀⠈⡄⠠⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠀⠢⠁⠆⠴⠐⠦⠘⠴⠈⠦⠱⠌⠦⠱⠌⠦⠡⠆⠔⠀⠥⢈⠤⠀⠈⠰⠁⠢⠘⠠⠄⠱⠈⠔⠱⠔⠱⠔⠔⠔⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⡀⢀⠀⡀⠄⢠⢀⠂⡌⡐⣠⢊⡤⠈⢿⣿⣿⣦⣷⡀⢨⣑⣀⠂⡌⢀⠄⡀⠠⢀⠀⡀⢀⠀⡀⢀⠀⡀⠠⢈⠄⠂⢠⣴⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⠄⠀⠀⢠⣶⣶⣶⠶⣶⠶⡶⡶⠶⢶⠰⠶⠶⠶⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠂⠡⠘⠄⠢⠑⠌⠲⠡⠚⠔⠪⠜⠴⠣⠗⠯⣟⣧⠀⢻⣿⣿⣿⣧⠀⠓⠮⠳⠜⠢⠎⠔⠣⠌⠆⠑⠂⠒⠄⠢⠐⢀⢣⡘⠄⢀⣾⣿⡟⡟⠛⢛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡻⡇⠀⠀⠀⣼⣟⠲⣹⠈⠑⡪⠑⠭⢣⡏⡆⡔⠆⠄⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢲⣶⣶⣴⣦⣴⣶⣤⣶⣴⣦⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣈⣿⣿⣿⣷⣤⣤⣤⣴⣶⣤⣶⣴⣶⣤⣶⣤⣦⣤⣤⣴⡆⠀⢲⣹⠀⣸⣿⣿⡅⠁⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠈⢿⡷⢳⠃⢠⡈⢰⡿⣚⢯⠃⢀⣤⣤⣴⠀⢠⠟⡰⠉⠆⠀⠂⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠀⣸⢳⡏⠀⣿⣿⣿⡇⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣰⣻⡧⡌⠀⡿⠁⣼⡳⢽⡏⠀⢸⡿⢿⡟⠀⣾⢡⠣⡜⠀⠨⠄⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠉⠉⠉⠉⢉⠉⢉⢉⢉⣉⣉⣉⡙⠛⢀⣴⣿⣿⣿⡿⠋⢀⣉⣈⣉⣉⣉⣉⣉⢉⡉⢉⡉⢉⣉⣉⡉⡉⠉⠉⠉⠉⠁⠀⠷⣻⠀⢸⣿⣿⣾⠀⣈⣁⣀⣁⣀⣁⣀⣈⣀⣈⣀⣀⣠⣿⡷⠹⠀⠠⠁⣰⡿⡱⡟⠀⢠⠿⢽⣻⠀⢸⡇⢎⡽⠁⢠⢃⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⢂⠘⡌⡙⢎⡻⣭⢿⣿⣿⠟⢉⣠⣾⣿⣿⣿⠟⠉⣠⣴⠿⣏⠿⣭⢻⡝⢾⣽⣻⢿⠛⠀⠈⠻⣎⠷⡩⠏⠹⠌⢓⠲⣒⠷⡎⠀⣾⣿⣿⡿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢯⣿⢿⡿⡁⠀⠀⢀⣴⣟⠳⡥⠁⢰⢏⡆⢸⠁⢀⣿⠘⠦⡟⠀⠚⠆⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠀⡔⣈⠖⣴⡽⡾⠃⣁⣴⣿⣿⣿⡿⠟⢁⣤⡿⣛⢦⡽⢤⣓⢦⣳⠼⣶⠏⠊⣁⣴⣿⣷⣤⠈⠂⡑⢢⠁⡌⠢⠥⡜⣯⠁⢸⣻⣿⡃⠀⣉⠉⡉⠉⠉⠉⢉⣉⡉⠉⠉⠈⠉⠉⢋⡀⠀⣠⣾⢟⡜⡿⠁⣠⢾⢠⣆⢨⠀⠰⡏⡜⡱⠳⠶⠶⠶⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢠⠡⡰⣌⠿⠈⢁⣤⣾⣿⣿⣿⠿⠋⣠⣶⣿⣭⣵⢪⡳⣜⣣⡜⣮⡗⠛⢀⣤⣾⣿⣿⣿⣿⠟⠃⠀⢠⠁⡐⢈⣁⠢⣍⠙⠀⣿⣿⢁⠃⢰⣿⠀⣼⣷⠞⠀⠀⡦⠀⠰⣿⠚⠄⠀⠀⠀⢼⡻⣝⣾⠟⢀⣰⣯⢧⡴⣌⢯⣀⠀⠻⣔⣡⢓⡰⢂⡜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢄⡡⠚⠁⣁⣤⣾⣿⣿⣿⡿⠛⣁⣴⣿⣿⡿⣿⠾⠽⠿⣽⠯⡷⠛⢁⣠⣶⣿⣿⣿⣿⠿⠋⢁⡀⠤⠘⡀⠐⡈⢠⢀⡉⡎⠀⢸⣿⡟⠈⠀⠘⠃⢠⣿⣿⡆⠀⠀⠀⠀⣴⣿⣥⠀⠀⠀⠀⠈⣷⠟⢁⣰⣾⣿⣯⡿⣼⢫⣟⣽⡶⡄⠀⠀⠉⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⢈⣠⣤⣾⣿⣿⣿⣿⣿⣏⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣴⣿⣿⣿⣿⡿⠛⠁⣀⠲⢁⠊⠐⠁⠠⠁⠄⡁⠊⡜⡃⢀⣿⣿⠇⠀⠘⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⢿⢛⣹⣇⣀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⣀⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠈⣿⣧⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⡭⠟⠉⠀⡔⠫⠌⠑⠂⠌⠠⠁⠂⠁⠒⠈⠱⠽⠀⣸⣿⡟⠠⠀⠄⠈⠿⣿⡿⡿⠉⠀⠋⠹⢾⣳⣭⠏⠀⠘⢸⢏⢯⡓⢮⠱⢩⠖⣱⢊⠦⡑⢆⠲⡐⠆⡔⠂⡛⠀⠠⠁⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠄⠀⢿⠿⠿⠟⠛⠛⠛⠛⠛⢛⠛⣛⣉⣙⠛⠛⢀⣤⣿⣿⣿⣿⠿⠋⠋⠀⠀⠀⠙⢮⠱⡈⠆⠁⠂⠐⠀⢂⠡⠌⠱⣃⠈⢀⣿⣿⠁⠄⢠⡆⠀⢢⣿⠁⠀⠀⣴⠀⠀⣾⠧⠇⢀⣠⣆⠀⠘⣿⡙⢾⡏⠉⣉⡁⢋⢉⡙⠈⠁⣸⠣⢌⡇⠀⠀⢂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠠⠀⢤⠰⡲⢞⡿⣻⣿⣿⣿⣿⣿⠟⢋⣠⣶⣿⣿⣿⣿⠟⠉⠀⠀⣀⣤⣾⣧⠀⢳⡒⡰⠠⢁⠂⡐⢀⠂⠰⣀⠳⣆⠀⣼⣿⡏⠠⢀⣸⠇⠀⣾⣯⡀⢀⣆⡘⠀⢰⢯⣶⠀⢾⣿⡻⠀⠀⣿⡙⢾⡇⠸⣿⣿⣿⣿⡟⢀⡴⡁⠎⡴⠁⠠⡐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⡁⢢⠡⡑⢬⡰⢧⣼⡗⠛⢉⣠⣶⣿⣿⣿⣿⠟⠋⣀⣴⣿⣆⠘⣿⣿⣿⣿⣇⠀⢳⠤⣁⠂⠄⠠⡀⠌⡰⢠⣛⠄⢠⣿⣿⣷⣄⣀⣠⣀⣾⣿⣿⣇⣤⣀⣀⣼⣯⢿⣧⣤⣤⣠⡄⠀⠀⢿⡙⢮⣤⠀⣿⣿⡿⠃⣠⠞⠤⣡⠟⠀⠀⠆⠠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠐⣀⢂⡱⣌⢧⡻⠋⢀⣤⣶⣿⣿⣿⣿⠟⠋⣀⣴⡻⢽⡉⢷⣻⡄⠘⣿⣿⣿⣿⡆⠈⢷⡠⢌⠠⣁⠐⡨⢄⡱⠎⠀⣾⣿⣿⣿⡛⢛⡛⠙⠛⠛⢟⣯⣛⣻⠋⠛⠜⢫⣞⣵⣫⣼⠇⠀⠀⢺⡝⡆⢿⡄⠸⠟⢁⡴⢃⢎⣲⠍⠀⡠⠡⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⡀⠂⣄⢂⢧⡚⠈⣁⣤⣾⣿⣿⣿⣿⠟⢉⣠⣴⡻⣍⡘⣥⢣⡝⣣⡝⣿⡄⠘⣿⣿⣿⣿⡄⠘⡵⣊⠔⡠⢡⣀⢣⡝⠀⢸⣿⡿⠱⠀⣤⣄⠀⢠⣤⣀⠀⠀⠀⠀⠀⣤⡄⠀⢠⣄⣄⣀⣀⣀⡃⠈⣷⠘⡭⠷⠀⡰⠟⡰⢩⡼⠃⠀⠤⡁⢀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⠂⡔⡱⠊⠋⣀⣤⣾⣿⣿⣿⣿⠟⠉⣠⣴⣿⣛⡾⣱⢧⣛⡴⡳⣜⢧⣟⣿⣿⡄⠙⣿⣿⣿⣿⡀⠙⣎⢎⡁⠒⣨⠗⠃⢠⣿⡿⢢⠁⢠⠟⢁⣴⣾⣿⡏⠗⠀⠀⢿⣿⢫⢿⣦⠘⢿⣿⣿⣟⣿⣿⡄⠸⡍⠲⣙⠫⡑⢪⡵⠋⢀⣠⠛⡀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠐⠂⠁⣀⣠⣴⣾⣿⣿⣿⣿⠟⠉⠠⠴⠟⠛⠛⠛⠙⠙⠉⠊⠁⣉⢉⣉⣈⣉⣈⣁⣉⡀⢹⣿⣿⣿⣷⡀⠹⣮⠝⣽⢣⠃⢠⣿⡿⠡⠃⠀⢀⣴⣿⡿⢏⠟⠁⣠⣾⣇⠈⢿⣏⠾⣹⣆⠈⢻⣿⣿⠿⠋⢁⣠⢀⠳⢄⡓⠼⠀⠀⠸⢿⡥⠓⡌⠠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣶⣾⣿⣿⣿⣿⣿⣿⣷⣤⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⣿⣿⣿⣿⣷⠀⢹⣟⠾⠃⣰⣿⣿⡿⠀⢀⣴⣿⣿⣿⠟⠁⢠⠾⠹⠺⢽⡆⠘⣯⣛⡴⣻⡧⠈⠋⣠⡤⢞⠫⡔⣉⠐⠊⠰⢡⡉⠟⢦⡄⠈⠓⠤⠁⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠐⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⠿⡿⠿⠿⠿⠿⠿⠿⠿⠿⠻⠟⠛⠛⠛⠀⠈⣿⣿⣿⣿⣧⠀⠛⢁⣴⣿⣿⣧⠀⣴⣿⣿⣿⠿⠃⢀⡜⠡⠚⠌⡓⢜⠺⡄⠸⣷⣟⣁⡤⡖⢯⡑⢎⢥⡳⠖⠁⢀⣀⠹⢆⡘⢌⠢⢌⠙⠲⠤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠿⠟⠋⠛⠉⣉⡉⣉⣀⣁⣀⣀⡠⢄⠤⡠⢄⠤⡰⢄⠲⡐⢆⠲⡐⢆⠲⡐⢦⢋⢟⡳⠀⢻⣿⣿⣿⠟⠁⠀⢻⣿⣿⡿⠁⣠⠀⠻⠿⠋⠀⡀⠆⡐⠠⠁⢂⠐⠠⢃⠦⠀⢿⡱⣊⠵⣪⡵⠚⠎⠉⣀⠤⠔⢯⢫⢆⡀⠙⠦⣁⠎⡈⢅⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⡈⠡⠄⡑⠠⢂⠰⢀⠂⠡⢈⠂⠁⠌⠀⢁⠈⢀⠐⠀⠄⠠⠀⠂⠈⠀⠌⠠⠈⠅⠈⠛⠉⠀⠠⢄⠃⡀⠻⠋⠀⡐⠤⠉⡀⠀⠀⡀⠄⠀⠀⠀⠀⠀⠀⢀⠂⠌⡀⠘⡷⠛⠉⠁⣀⠠⢄⡘⠤⠁⠌⠠⢀⠊⡘⠤⢀⠀⠉⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠁⠈⠀⠀⠀⠈⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠂⠄⠁⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠂⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ]]
    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.buttons.val = {
      -- dashboard.button("f", "  查找文件", ":Telescope find_files <CR>"),
      -- dashboard.button("n", "  新建文件", ":ene <BAR> startinsert <CR>"),
      -- dashboard.button("g", "  文本搜索", ":Telescope live_grep <CR>"),
      -- dashboard.button("r", "  最近文件", ":Telescope oldfiles <CR>"),
      dashboard.button("c", "  配置", ":e $MYVIMRC <CR>"),
      -- dashboard.button("s", "  恢复会话", "session"),
      -- dashboard.button("x", "  扩展插件", ":LazyExtras<CR>"),
      -- dashboard.button("l", "󰒲  插件管理", ":Lazy<CR>"),
      dashboard.button("q", "  退出", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    dashboard.opts.layout[1].val = 2
    return dashboard
  end,
  config = function(_, dashboard)
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        if #vim.fn.getbufinfo({ buflisted = true }) == 0 then
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ 加载了 " .. stats.count .. " 个插件，用时 " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end
      end,
    })
    require("alpha").setup(dashboard.opts)
  end,
}