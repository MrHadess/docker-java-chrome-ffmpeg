# date 2025-03-17 22:40
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
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get install -y ffmpeg \
    # Install ChromeDriver (MatchLatestStableChrome)
    && CHROME_MAJOR_VERSION=$(google-chrome-stable --version | awk -F '[ .]' '{print $3}') \
    && CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_MAJOR_VERSION") \
    && echo "DownloadChromedriverVersion: $CHROMEDRIVER_VERSION" \
    && wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    # Config CH ENV
    && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && fc-cache -fv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/chromedriver.zip

# Setting Chinese ENV
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# Set the working directory
WORKDIR /app

# Default command
CMD ["bash"]
