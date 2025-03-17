# Use OpenJDK as the base image
FROM openjdk:17-jdk-slim

# Define environment variable (modify the target version number here)
ENV CHROME_VERSION=116.0.5845.96

# Install Chrome, WebDriver, FFmpeg, and Chinese fonts
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    unzip \
    fontconfig \
    fonts-noto-cjk-extra \
    ttf-wqy-microhei \
    locales \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    # Force install the specified version (must include the full package version number)
    && apt-get install -y google-chrome-stable=${CHROME_VERSION}-1 \
    && apt-get install -y ffmpeg \
    # Install the corresponding version of Chromedriver (download URL constructed using version number)
    && wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROME_VERSION}/chromedriver_linux64.zip" \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    # Configure the Chinese locale
    && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && fc-cache -fv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/chromedriver.zip

# Configure zh_CN locale environment
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# Set the working directory
WORKDIR /app

# Default command
CMD ["bash"]
