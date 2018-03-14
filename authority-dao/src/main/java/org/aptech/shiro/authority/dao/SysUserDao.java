package org.aptech.shiro.authority.dao;

import org.apache.ibatis.annotations.Param;
import org.aptech.shiro.authority.pojo.SysUser;

public interface SysUserDao extends CommonDao<SysUser, Integer> {
 
	public SysUser getByUsername(@Param("username") String username);
	public void addUserRole(@Param("userId") Integer userId,@Param("roleIds") Integer[] roleIds);

	public void deleteRelationByUserId(Integer userId);

}
