package org.aptech.shiro.authority.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.aptech.shiro.authority.dao.SysPermissionDao;
import org.aptech.shiro.authority.dao.SysRoleDao;
import org.aptech.shiro.authority.pojo.SysRole;
import org.aptech.shiro.authority.pojo.SysUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/role")
public class SysRoleController {
	@Resource
	private SysRoleDao sysRoleDao;
	
	@Resource
	private SysPermissionDao sysPermissionDao;
	
	
	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}
	public void setSysRoleDao(SysRoleDao sysRoleDao) {
		this.sysRoleDao = sysRoleDao;
	}
	@RequestMapping("/all")
	@ResponseBody
	public List<SysRole> all() throws Exception{
		return sysRoleDao.getAll();
	}
	@RequestMapping("/toAssign")
	public String toAssign(Integer rid,ModelMap modelMap) throws Exception{
		modelMap.put("roleId", rid);
		
		return "sysRole/assign";
	}
	@RequestMapping("/getPermission")
	@ResponseBody
	public List<Integer> selectPermission(Integer roleId) throws Exception{
		return sysPermissionDao.getPermissionIdsByRoleId(roleId);
	} 
	
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index() throws Exception {
		return "sysRole/index";
	}
}
