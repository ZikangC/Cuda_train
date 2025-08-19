__global__ void reduce(float* input, float* output, int N){
    int allidx = blockDim.x * blockIdx.x + threadIdx.x;
    int idx = threadIdx.x;
    int len = 256;
    __shared__ float  blockdata[256];
    blockdata[idx] = input[allidx];
    __syncthreads();
    while(len > 1){
        if(idx < len / 2){
            blockdata[idx] = blockdata[idx] + blockdata[idx + len / 2];
        }
        __syncthreads();
        len = len /2;
    }
    if(idx == 0){
        output[blockIdx.x] = blockdata[0];
    }
    return;
}
