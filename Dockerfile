FROM python:3.9-slim

RUN apt-get -y update && apt-get install -y \
    autoconf \
    bison \
    flex \
    gcc \
    g++ \
    git \
    libprotobuf-dev \
    libnl-route-3-dev \
    libtool \
    make \
    pkg-config \
    protobuf-compiler \
    libseccomp-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build nsjail
RUN git clone https://github.com/google/nsjail.git /tmp/nsjail \
&& cd /tmp/nsjail \
&& make \
&& cp nsjail /usr/local/bin/nsjail \
&& rm -rf /tmp/nsjail

# Copy your application files
COPY . /app
WORKDIR /app

# Install dependencies
RUN pip install -r requirements.txt

# Ensure the dynamic linker can find the Python library
RUN ln -s /usr/local/lib/libpython3.9.so.1.0 /usr/lib/libpython3.9.so.1.0

# Expose the port
EXPOSE 8080

# Command to run the Flask app
CMD ["python", "app.py"]

