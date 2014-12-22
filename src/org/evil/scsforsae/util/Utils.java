package org.evil.scsforsae.util;

public class Utils {

	public static String formatSize(long size) {
		long SIZE_KB = 1024;
		long SIZE_MB = SIZE_KB * 1024;
		long SIZE_GB = SIZE_MB * 1024;

		if (size < SIZE_KB) {
			return String.format("%d B", (int) size);
		} else if (size < SIZE_MB) {
			return String.format("%.2f KB", (float) size / SIZE_KB);
		} else if (size < SIZE_GB) {
			return String.format("%.2f MB", (float) size / SIZE_MB);
		} else {
			return String.format("%.2f GB", (float) size / SIZE_GB);
		}
	}
	
}
