+++
tags = ["java","面试","多线程"]
title = "经典问题之生产者-消费者问题——Lock实现"
draft = false
date = "2017-03-03T10:54:24+02:00"

+++





	import java.util.LinkedList;
	import java.util.List;
	import java.util.concurrent.locks.Condition;
	import java.util.concurrent.locks.ReentrantLock;
	
	class Producer implements Runnable {
	    public Storage storage;
	
	    public Producer(Storage s) {
	        this.storage = s;
	    }
	
	    public void run() {
	        storage.produce();
	    }
	}
	
	class Consumer implements Runnable {
	    public Storage storage;
	
	    public Consumer(Storage s) {
	        this.storage = s;
	    }
	
	    public void run() {
	        storage.consume();
	    }
	}
	
	public class Storage {
	
	    public static final int size = 20;
	
	    List<Object> storage = new LinkedList<Object>();
	    ReentrantLock lock = new ReentrantLock();
	    Condition full = lock.newCondition();
	    Condition empty = lock.newCondition();
	
	    public void produce() {
	        try {
	            lock.lock();
	            if (storage.size() == size) {
	                full.await();
	            }
	            storage.add(new Object());
	            System.out.println("produce ; size = " + storage.size());
	            empty.signal();
	            Thread.sleep(200);
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            lock.unlock();
	        }
	    }
	
	    public void consume() {
	        try {
	            lock.lock();
	            if (storage.size() == 0) {
	                empty.await();
	            }
	            storage.remove(0);
	            full.signal();
	            System.out.println(" consume ; size = " + storage.size());
	            Thread.sleep(200);
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            lock.unlock();
	        }
	    }
	
	    public static void main(String[] args) {
	        Storage s = new Storage();
	        for (int i = 0; i < 100; i++) {
	            Producer p = new Producer(s);
	            Thread thread = new Thread(p);
	            thread.start();
	        }
	        for (int i = 0; i < 100; i++) {
	            Consumer c = new Consumer(s);
	            Thread thread2 = new Thread(c);
	            thread2.start();
	        }
	    }
	}