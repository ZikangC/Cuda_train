__global__ void gmme(float* A, float* B, float* C, int M,int  N){
    int col = blockDim.x * blockIdx.x + threadIdx.x;
    int row = blockDim.y * blockIdx.y + threadIdx.y;
    int idx = threadIdx.x;
    int idy = threadIdx.y;
    int once = blockDim.x * blockDim.y * gridDim.x * gridDim.y
    int cnt = M * N / once;
    __shared__ float blockdataA[256];
    __shared__ float blockdataB[256];
    while(cnt--){
        blockdataA[idy * N + idx] = A[row * N + col];
        blockdataB[idy * N + idx] = B[row * N + col];
        __syncthreads();
        for(int i = 0; i < N; i++){
            C[idy * N + idx] += blockdataA[idy * N + i] * B[i * N + idx];
        }
    }
    __syncthreads();
    return;
}
