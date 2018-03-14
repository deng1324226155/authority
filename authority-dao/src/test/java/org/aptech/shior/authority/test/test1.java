package org.aptech.shior.authority.test;

import static org.junit.Assert.*;

import java.util.List;

import javax.annotation.Resource;

import org.aptech.shiro.authority.dao.SysPermissionDao;
import org.aptech.shiro.authority.dao.SysRoleDao;
import org.aptech.shiro.authority.dao.SysUserDao;
import org.aptech.shiro.authority.pojo.SysPermission;
import org.aptech.shiro.authority.pojo.SysRole;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-mybatis.xml")
public class test1 {

	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private SysRoleDao sysRoleDao;
	@Resource
	private SysPermissionDao sysPermissionDao;
	
	
	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}



	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}
	
	
	
	public void setSysRoleDao(SysRoleDao sysRoleDao) {
		this.sysRoleDao = sysRoleDao;
	}



	@Test
	public void test() {
		
		List<SysRole> list = sysRoleDao.getAll();
		for (SysRole sysRole : list) {
			System.out.println(sysRole);
		}
	}

	
}
