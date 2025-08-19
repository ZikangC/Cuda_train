#define blocksize  32
__global__ void gmme(float* A, float* B, float* C, int N){
    int col = blockDim.x * blockIdx.x + threadIdx.x;
    int row = blockDim.y * blockIdx.y + threadIdx.y;
    int idx = threadIdx.x;
    int idy = threadIdx.y;
    const int n = blocksize;
    __shared__ float blockdataA[n*n];
    __shared__ float blockdataB[n*n];
    float sum = 0.0;
    for(int i = 0; i < N/n; i++){
        blockdataA[idy*n + idx] = A[row*N + i*n + idx];
        blockdataB[idy*n + idx] = B[(idy + i*n) * N + col];
        __syncthreads();
        for(int j = 0; j < n; j++){
            sum += blockdataA[idy * n + j] * blockdataB[j * n + idx];
        }
        __syncthreads();
        
    }
    C[row * N + col] = sum;
    return;
}
