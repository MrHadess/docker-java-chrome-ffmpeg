# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim

# Install Chrome, WebDriver, FFmpeg and Chinese fonts
RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    curl \
    unzip \
    fontconfig \
    fonts-noto-cjk-extra \
    ttf-wqy-microhei \
    locales \
    jq \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get install -y ffmpeg \
    # 精确版本获取逻辑
    && CHROME_VERSION=$(google-chrome-stable --version | awk -F '[ .]' '{print $3"."$4"."$5}') \
    && CHROME_MAJOR=$(echo $CHROME_VERSION | cut -d'.' -f1) \
    && CHROMEDRIVER_VERSION=$(curl -sS "https://googlechromelabs.github.io/chrome-for-testing/latest-versions-per-milestone-with-downloads.json" | jq -r ".milestones.\"$CHROME_MAJOR\".version") \
    && echo "确认Chromedriver版本: $CHROMEDRIVER_VERSION" \
    && wget -O /tmp/chromedriver.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip" \
    && unzip /tmp/chromedriver.zip -d /tmp/ \
    && mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    # 中文环境配置
    && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && fc-cache -fv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# 设置中文环境变量
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# Set the working directory
WORKDIR /app

# Default command
CMD ["bash"]
