package util;

import java.util.List;

public class PagedResult<T> {
	private List<T> results;
	private int totalCount;
	private int page;
	private int size;
	
	public PagedResult(List<T> results, int totalCount, int page, int size) {
		this.results = results;
		this.totalCount = totalCount;
		this.page = page;
		this.size = size;
	}

	public List<T> getResults() {
		return results;
	}

	public void setResults(List<T> results) {
		this.results = results;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}
}
