+++
tags = ["算法"]
title = "排序.java"
draft = false
date = "2017-02-15T10:54:24+02:00"

+++







	public test{
		
	
		public static void main(String[] args){
	
	
			int[] a = new int[]{1,2};
	
			int n = a.length;
	
			//冒泡排序
			bubblesort(a , n);
	
			//选择排序
			sellectionSort(a,n);
	
	
	
			//直接插入排序
			insertionSort(a,n);
	
	
			//归并排序
			GBsort(a,0,n-1);
	
	
			//快速排序
			quickSort(a,left,right);
	
	
	
			//希尔排序
			shellSort();
	
	
		}
	
	
	
	
	
		//希尔排序
	
		public void shellSort(int[] a ,int n){
	
				for(int gap = n/2;gap>0;gap/=2){            				// 步长
	
					for (int i=gap; i<n ;i++) { 							// 直接插入排序的次数
	
						for(int j=i-gap;j>0 && a[j]>a[j+gap];j-=gap){        // 交换方式的直接插入排序
							swap(a[j],a[j+gap]);
						}
					}
				}
		}
	
	
	
	
	
		//快速排序
	
	
		public void quickSort(int[] a ,int left,int right){
	
			if(left<right){
	
				int middle = QSort(a,left,right);
				quickSort(a,left,middle);
				quickSort(a,middle+1,right);
	
			}
		}
	
	
		public int QSort(int[] a,int left,int right){
	
	
			int key = a[left];
	
			int l = left;
	
			int r = right;
	
			if(left<right){
	
				while(l<r){
	
	
					while(l<r && a[r]>=key){
						r--;
					}
	
					if(l<r){
						a[l]=a[r];
					}
	
					while(l<r && a[l]<=key){
						l++;
					}
	
					if(l<r){
						a[r]=a[l];
					}
	
				}
	
				a[l]=key;
	
			}	
	
			return l;
	
		}
	
	
	
	
	
		// 归并排序
	
		public void GBsort(int[] a,int left,int right){
	
			if(left<right){
				int middle = (left+right)/2;
				GBsort(a,left,middle);
				GBsort(a,middle+1,right);
				merge(a,left,middle,right);
			}
		}
	
	
		public void merge(int[] a,int left,int middle,int right){
	
			int[] tempArr = new int[right-left+1] ;                             //  new 出来数组，大小为 右 - 左 + 1 
	
			int leftIndex = left;
			int rightIndex = middle+1;
	
			int tempIndex=0;
	
			while(leftIndex<=middle && rightIndex<=right){
				
				if(a[leftIndex]<a[rightIndex]){
					
					tempArr[tempIndex++]=a[leftIndex++];
				}else{
					tempArr[tempIndex++]=a[rightIndex++];
				}
	
			}
	
			while(leftIndex<middle+1){
				temp[tempIndex++]=a[leftIndex++];
			}
	
			while(rightIndex<right+1){
				temp[tempIndex++]=a[rightIndex++];
			}
	
			int temp = 0;                                                //temp是两个数组的相对位置的下标，但原数组left不一定是0，所以得加上left
			while((left+temp)<=right）{
				a[left+temp]=temp[temp];
				temp++;
			}
	
		}
	
	
	
		//直接插入排序
	
		public int[] insertionSort(int[] a,int n){
	
			for(int i=1;i++;i<n){
				int temp = a[i];
				for(int j=i;j>0&&a[j-1]>temp;j--){
					a[j]=a[j-1];
				}
				a[j]=temp;
			}
		}
	
	
		//选择排序
		public int[] sellectionSort(int[] a,int n){
	
			for(int i=0;i<n-1;i++){
	
				int index=i;
				for(int j=i+1;j<n;j++){
					if(a[j]>a[index]){
						index = j;
					}	
				}
				swap(a[index],a[i]);
				
			}
	
		}
	
	
	
	
	
		//冒泡排序
	
		public int[] bubbleSort(int[] a,int n){
	
	
	
			for(int i=0;i<n-1;i++){                    //排序的次数是n-1不是n
	
				for(int j=0;j<n-i+1;j++){
					if(a[j]>a[j+1]){                   //注意这个地方，不是a[i]和a[j]的比较，是j和j+1的比较。i是排序的次数。
						swap(a[j],a[j+1]);
					}
				}
			}
	
			return a;
	
		}
	
		
	
	
		public void swap(int a, int b){
			int temp = a;
			a = b;
			b = temp;
		}
	
	
	
	}