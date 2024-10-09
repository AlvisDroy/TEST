name: Auto Update Subscription Nodes

on:
  # 允许手动触发工作流
  workflow_dispatch:
  # 定时触发工作流
  schedule:
    - cron: '0 18 * * *'  # 每天凌晨 02:00 UTC 运行

jobs:
  update-subscription:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Git user
      run: |
        git config --global user.name "AlvisDroy"
        git config --global user.email "alvis593088386@gmail.com"

    - name: Pull latest changes from remote
      run: |
        git pull origin main --rebase

    - name: Fetch and update subscriptions
      run: |
        curl -o 15 -H "User-Agent: clash-verge/v1.5.1" "https://x.yoy.pp.ua/api/v1/client/subscribe?token=7621729947c96c34b8759343eb056103"
        curl -o 12 -H "User-Agent: clash-verge/v1.5.1" "https://jc.sux.lol/api/v1/client/subscribe?token=374aac25cdcdbcc2c54961ba6b0e30ee"
        curl -o 11 -H "User-Agent: Mozilla/5.0 (Linux; Android 13; Mi 10 Build/TKQ1.221114.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.6668.9 Mobile Safari/537.36" "https://s.36y.me/v3/subscr?id=2e40fe91ce8c4864b1287b9a260ecaa7"
        curl -o 10 -H "User-Agent: clash-verge/v1.5.1" "https://sub.kaiche.tk/?token=auto"
        curl -o 9 -H "User-Agent: clash-verge/v1.5.1" "https://raw.githubusercontent.com/ripaojiedian/freenode/main/clash"
        curl -o 7 -H "User-Agent: clash-verge/v1.5.1" "https://sub.shengbenku.tk/sub.txt"
        curl -o 6 -H "User-Agent: clash-verge/v1.5.1" "https://sub.tgzdyz2.xyz/sub"
        curl -o 5 -H "User-Agent: clash-verge/v1.5.1" "https://cfno1.212124.xyz/clash?host=word.212124.xyz&uuid=97e9e73d-2a29-4a1e-b451-093d81c51f7b&path=/xkaopf15da"
        curl -o 4 -H "User-Agent: clash-verge/v1.5.1" "https://sub.xf.free.hr/auto"
        curl -o 3 -H "User-Agent: Mozilla/5.0 (Linux; Android 13; Mi 10 Build/TKQ1.221114.001) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.6668.9 Mobile Safari/537.36" "https://sub.443888.xyz/vless"
        curl -o 2 -H "User-Agent: clash-verge/v1.5.1" "https://pqjc.site/api/v1/client/subscribe?token=8bcfa970c037de514b087a4750406631"
        curl -o 1 -H "User-Agent: clash-verge/v1.5.1" "https://bpb-6fi.pages.dev/sub/89b3cbba-e6ac-485a-9481-976a0415eab9#BPB-Normal"
        cat 15 12 11 10 9 7 6 5 4 3 2 1 > all
        git add 15 12 11 10 9 7 6 5 4 3 2 1 all
        git commit -m "Update subscription nodes"

    - name: Force push changes to main branch
      run: git push origin main --force

    - name: Switch to gh-pages branch
      run: |
        git checkout gh-pages || git checkout --orphan gh-pages

    - name: Copy subscription file to GitHub Pages
      run: |
        cp all_nodes.txt index.txt  # 将文件复制并重命名为index.txt，这样可以通过URL直接访问
        git add index.txt
        git commit -m "Update GitHub Pages with latest subscription nodes"

    - name: Force push to gh-pages branch
      run: git push origin gh-pages --force