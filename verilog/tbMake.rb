# tb code gen

require 'pp'
require 'fileutils'
include FileUtils

class TbMake
  def initialize(filename)
    @filename = filename.split(".").shift
    @tbname = "tb_"+@filename
    @decname = []
    @mods = 0	#何個目のモジュール化を数える
    @sepMark = '/*----------------------------------------------------------------*/'
  end
  def exe
    read
    createBefore
    createTb
  end
  def read
    begin
      file = open(@filename+".v")
    rescue => ex
      puts ex
      exit
    end
    inout = nil
    # 1文読み込みの繰り返し
    while rline = file.gets do
      rline, file = commentHandle(rline,file)
      signalFair(rline)
    end
  end
  def signalFair(rline)
    if(/(input|output\s+reg|output)\s*(\[[0-9]+:[0-9]+\]|\s)\s*(.+)/ =~ rline)
      dectmp = $1
      plange = $2
      # ポートの範囲が1bitのとき
      if plange == "\s"
        plange = nil
      end
      # 信号名は単語だけ抜き取る
      tmp = $3
      # 区切り文字で分ける
      tmp_sp = tmp.split(/(,|;|\s)/)
      # 空白、区切り文字だけの配列要素を削除
      tmp_delspc = tmp_sp.delete_if{|item| item =~ /(,|;|^\s+$|^$)/}
      if (dectmp =~ /output\s+reg/)
        deckind = "output reg"
      else
        deckind = dectmp
      end
      @decname.push([deckind, plange, tmp_delspc])
    end
  end
  def commentHandle(line, file)
    if /\/\*/ =~ line
      while !(/\*\// =~ line)
        line = file.gets
      end
      return line, file
    end
    if /\/\// =~ line
      tmp = line.split(/\/\//)
      return tmp[0], file
    else
      return line, file
    end
  end
  def createBefore
    fileData = nil
    @save_data = []
    begin
      open(@tbname+".v", "r"){|file|
        # wfileの中身を全て読み込んで配列に入れる
        fileData = file.readlines
        #backup作成
        begin
          open("backup/"+@tbname+".v.bak", "w"){|f|
            fileData.each{|line|
              f.puts(line)
            }
          }
        rescue => ex
          puts ex
          puts "direcotry backup/ maked"
          mkdir_p("backup")
        end
        autoflag = false
        # 自動生成部分を削除
        fileData.each{|item|
          if item =~ /\/\*---auto creating---\*\//
            autoflag = true
          end
          @save_data.push(item) if !autoflag
          if item =~ /\/\*---auto created ---\*\//
            autoflag = false
          end
        }
      }
    rescue => nofile	# 下位モジュールのファイルが無かった時
      puts nofile
      puts "file：#{@tbname}.v cant open, create newfile"
    end
  end
  def createTb
    begin
      open("tb_"+@filename+".v", "w"){|file|
        file.puts("/*---auto creating---*/")
        file.puts("`timescale 1ns/10ps")
        file.puts("module "+@tbname+";")
        file.puts(@sepMark)
        file.puts("/* parameters */")
        file.puts(@sepMark)
        file.puts("parameter P_CYCLE_CLK = 10;")
        file.puts("parameter STB = 1;")
        file.puts("parameter outfile = \"output.txt\";")
        file.puts("")
        file.puts(@sepMark)
        file.puts("/* regsters */")
        file.puts(@sepMark)
        file.puts("integer i;")
        file.puts("")
        file.puts(@sepMark)
        file.puts("/* regs and wires */")
        file.puts(@sepMark)
        @decname.each{|inout, lange, name|
          if lange == nil
            lange = "\s\s\s\s\s\s\s"
          end
          if name[1] != nil
            p "nankaerror"
            p "name remained: #{name}"
            next
          end
          if(inout == "input")
            file.puts("\s\sreg\s#{lange}\tr_#{name[0].downcase};")	#最後の宣言ならカンマいらない
          elsif(inout == "output")
            file.puts("\s\swire\s#{lange}\tw_#{name[0].downcase};")	#最後の宣言ならカンマいらない
          end
        }
        file.puts("")
        file.puts(@sepMark)
        file.puts("/* testmodule */")
        file.puts(@sepMark)
        file.puts("#{@filename} u_#{@filename}")
        file.puts("(")
        i = 0
        @decname.each{|inout, lange, name|
          if lange == nil
            lange = "\s\s\s\s\s\s\s"
          end
          if name[1] != nil
            p "nankaerror"
            next
          end
          if(inout == "input")
            if(@decname[i+1] == nil)
              file.puts("\s\s.#{name[0]}(r_#{name[0].downcase})")	#最後の宣言ならカンマいらない
            else
              file.puts("\s\s.#{name[0]}(r_#{name[0].downcase}),")
            end
          elsif(inout == "output" || inout == "output reg")
            if(@decname[i+1] == nil)
              file.puts("\s\s.#{name[0]}(w_#{name[0].downcase})")	#最後の宣言ならカンマいらない
            else
              file.puts("\s\s.#{name[0]}(w_#{name[0].downcase}),")
            end
          end
          i += 1
        }
        file.puts(");")
        file.puts("")
        file.puts(@sepMark)
        file.puts("/* generate clk */")
        file.puts(@sepMark)
        file.puts("always begin")
        file.puts("#(P_CYCLE_CLK/2) r_clk = ~r_clk;")
        file.puts("end")
        file.puts("")
        file.puts(@sepMark)
        file.puts("/* body */")
        file.puts(@sepMark)
        file.puts("initial begin")
        tmp_name = []
        @decname.each{|inout, lange, name|

          if name[1] != nil
            p "nankaerror"
            next
          end

          if inout == "input"
            if(/_(x|X)/ =~ name[0])
              file.puts("\s\sr_#{name[0].downcase} = 0;")
              tmp_name.push("r_#{name[0].downcase}")
            else
              file.puts("\s\sr_#{name[0].downcase} = 0;")
            end
          end
        }
        file.puts("#(STB)")
        tmp_name.each{|name|
          file.puts("\s\s#{name} = 1;")
        }
        file.puts('/*---auto created ---*/')
        @save_data.each{|line|
          file.write(line)
        }
      }
    rescue => ex
      puts ex
      exit
    end
  end
end

#-------------------------------------------------
#main
#-------------------------------------------------
tbmake = TbMake.new(ARGV[0])
tbmake.exe
