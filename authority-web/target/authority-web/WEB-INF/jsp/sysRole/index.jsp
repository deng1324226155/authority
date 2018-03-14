<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="easyui/themes/material/easyui.css"/>
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css"/>
<script type="text/javascript">
$(function(){
	$("#roleTable").datagrid({
		pagination:true,
		toolbar:"#tb",
		idField:"id",
		onLoadSuccess:function(){
			$("a.op").tooltip({
				position:'right'
			});
		}
	});
})
	function availableFormatter(value,row,index){
		if(value == 0){
			return "否";
		}
		return "是";
	}
	function opFormatter(value,row,index){
		return "<a href='javascript:void(0)' title='分配权限' onclick='assignPermission("+row.id+")' class='op'><img src='easyui/themes/icons/large_chart.png'/></a>";
	}
	
	function assignPermission(roleId){
		$("roleTable").datagrid("clearSelections");
		var d =$("<div></div>").appendTo("body");
		d.dialog({
			title:"分配权限",
			width:250,
			height:350,
			href:"role/toAssign?rid="+roleId,
			modal:true,
			onClose:function(){$(this).dialog("destroy");},
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){}
				var nodes = $("assignTree").tree("getChecked","checked");
				var half_nodes = $("#assignTree").tree("getChecked","indeterminate");
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
	//按条件查询
	
	function setCondition(){
		var postData = {username : $("#username").val()};
		var ids = $("#roles").combobox("getValues");
		for(var i = 0; i < ids.length ; i++){
			postData["sysRoles["+i+"].id"] = ids[i];
		}
		
		$("#userTable").datagrid("reload",postData);
	}
	function resetCondition(){
		$("#userCondition").form("clear");
	}
	//删除用户
	function delete_user(){
		//获取
		var selRows = $("#userTable").datagrid("getSelections");
		if(selRows.length == 0){
			$.messager.alert("提示","请选择要删除的数据行","warning");
			return;
		}
		$.messager.confirm("提示","请选择要删除的数据行",function(r){
			if(r){
				var postData = "";
				$.each(selRows,function(i){
					postData += "ids="+this.id;
					if(i < selRows.length - 1){
						postData +="&";
					}
				});
				$.post("user/batchDelete",postData,function(data){
					if(data.result == true){
						$("#userTable").datagrid("reload");
					}
				});
			}
		});
	}

	function add_user(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加用户",
			iconCls : "icon-add",
			width:500,
			height:300,
			modal:true,
			href : "user/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "user/add",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
	function edit_user(){
		var row = $("#userTable").datagrid("getSelected");
		if(row == null){
			return;
		}

		//如果选中了多个，只保留row这个
		$("#userTable").datagrid("clearSelections");
		$("#userTable").datagrid("selectRecord",row.id);
		
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "编辑用户",
			iconCls : "icon-edit",
			width:500,
			height:300,
			modal:true,
			href : "user/form",
			onClose:function(){$(this).dialog("destroy"); },
			onLoad:function(){
				//发送异步请求，查询数据
				$.post("user/view",{id:row.id},function(data){
					$("#userForm").form("load",data);
					var roles = new Array();
					$.each(data.sysRoles,function(){
						roles.push(this.id);
					});
					$("#roles_form").combobox("setValues",roles);
				});
			},
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "user/edit",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
</script>
</head>
<body>
	<table id="roleTable" title="role list"
			data-options="url:'role/all',fitColumns:true,striped:true,rownumbers:true,iconCls:'icon-search'">
		<thead>
			<tr>
				<th data-options="field:'tyu',checkbox:true"></th>
				<th data-options="field:'id',width:30">Id</th>
				<th data-options="field:'name',width:100,">name</th>
				<th data-options="field:'available',width:100,sortable:true,formatter:availableFormatter">available</th>
				<th data-options="field:'world',width:50,formatter:opFormatter">操作</th>
			</tr>
		</thead>
</table>

<div id="tb">
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_user();" data-options="iconCls:'icon-add',plain:true">添加</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_user();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_user();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
</body>
</html>