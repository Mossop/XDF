<?php

	class XmlElement
	{
	
		var $attributes;
		var $elements;
		var $type;
		var $content;
		
		function XmlElement()
		{
			$this->attributes=array();
			$this->elements=array();
			$this->type="Unspecified";
			$this->content="";
		}
		
		function addElement(&$element)
		{
			$this->elements[]=&$element;
		}
		
		function setAttribute($attribute,$value)
		{
			$this->attributes[$attribute]=$value;
		}
		
		function getAttribute($attribute)
		{
			if (isset($this->attributes[$attribute]))
			{
				return $this->attributes[$attribute];
			}
			else
			{
				return false;
			}
		}

		function setContent($text)
		{
			$this->content=$text;
		}
		
		function getContent()
		{
			return $this->content;
		}
		
		function setType($newtype)
		{
			$this->type=$newtype;
		}
		
		function formattedString($indent)
		{
			$content="$indent<".$this->type;
			foreach ($this->attributes as $attribute => $value)
			{
				$content=$content." $attribute=\"".htmlspecialchars($value)."\"";
			}
			if ((count($this->elements)==0)&&(strlen($this->content)==0))
			{
				$content=$content."/>\n";
			}
			else
			{
				$content=$content.">\n";
				foreach ($this->elements as $elem)
				{
					$content=$content.$elem->formattedString("  $indent");
				}
				if (strlen($this->content)>0)
				{
					$content=$content."  $indent".htmlspecialchars($this->content)."\n";
				}
				$content=$content."$indent</".$this->type.">\n";
			}
			return $content;
		}
		
		function toString()
		{
			return $this->formattedString("");
		}
	}
	
	class XmlDoc
	{
		var $root;
		
		function XmlDoc()
		{
			$this->root = new XmlElement;
		}
		
		function &getRootElement()
		{
			return $this->root;
		}

		function toString()
		{
			$content="<?xml version=\"1.0\"?>\n\n";
			$content=$content.$this->root->toString();
			return $content;
		}
	}
	
?>