# FROM nsjailcontainer AS nsjail  

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

# COPY . /nsjail

# RUN cd /nsjail && make && mv /nsjail/nsjail /bin && rm -rf -- /nsjail

# Install any additional Python packages
# RUN python -m pip install --upgrade pip setuptools

# Copy your application files
COPY . /app
WORKDIR /app

# RUN cd /nsjail && make && mv /nsjail/nsjail /bin && rm -rf -- /nsjail

# Install dependencies
RUN pip install -r requirements.txt

# # Copy the nsjail binary from the nsjail stage
# COPY --from=nsjail /bin/nsjail /bin/nsjail
# COPY --from=nsjail /usr/lib/x86_64-linux-gnu/libprotobuf.so.10 /usr/lib/x86_64-linux-gnu/
# COPY --from=nsjail /usr/lib/x86_64-linux-gnu/libnl-route-3.so.200 /usr/lib/x86_64-linux-gnu/
# COPY --from=nsjail /lib/x86_64-linux-gnu/libseccomp.so.2 /lib/x86_64-linux-gnu/
# COPY --from=nsjail /lib/x86_64-linux-gnu/libnl-3.so.200 /lib/x86_64-linux-gnu/

# Ensure the dynamic linker can find the Python library
RUN ln -s /usr/local/lib/libpython3.9.so.1.0 /usr/lib/libpython3.9.so.1.0

# Expose the port
EXPOSE 8080

# Command to run the Flask app
CMD ["python", "app.py"]

