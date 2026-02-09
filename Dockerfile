FROM ros:jazzy-ros-base
SHELL [ "/bin/bash", "-c" ]

RUN apt-get update && apt-get install -y \
    nano \
    curl \
    lsb-release \
    gnupg2 \
    ros-jazzy-cartographer \
    ros-jazzy-cartographer-ros \
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup \
    python3-colcon-common-extensions \
    python3-argcomplete \
    libboost-system-dev \
    build-essential \
    ros-jazzy-hls-lfcd-lds-driver \
    ros-jazzy-turtlebot3-msgs \
    ros-jazzy-dynamixel-sdk \
    ros-jazzy-xacro \
    libudev-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc
RUN echo 'export ROS_DOMAIN_ID=30' >> ~/.bashrc

WORKDIR /root/turtlebot3_ws/src
RUN git clone -b jazzy https://github.com/ROBOTIS-GIT/turtlebot3.git \
    && git clone -b jazzy https://github.com/ROBOTIS-GIT/ld08_driver.git \
    && git clone -b jazzy https://github.com/ROBOTIS-GIT/coin_d4_driver.git

WORKDIR /root/turtlebot3_ws/src/turtlebot3/
RUN rm -r turtlebot3_cartographer turtlebot3_navigation2

WORKDIR /root/turtlebot3_ws/
RUN echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc 

RUN /bin/bash -c " source /opt/ros/jazzy/setup.bash \
    && colcon build --symlink-install --parallel-workers 1 "\
    && echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc \
    && source ~/.bashrc \
    && echo 'export LDS_MODEL=LDS-01' >> ~/.bashrc \
    && source ~/.bashrc

