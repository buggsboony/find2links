import std.stdio;
import std.process;
import std.array; //to use str.split("\n");
import std.path; //2023-11-05 19:48:44 - baseName() extension()
import std.file;
import std.string;
import core.stdc.stdlib; //2023-11-18 12:18:39 - exit(0);

const APP_NAME = "Find2Links";

/*
 find /usr/share/hydrogen -iname "*kick*"
*/

int[string] OCCURRENCES; //Memory

int tryCreateLink(string filename,string destfilename)
{
    
    if( std.file.exists(destfilename) )
    {
            //try check if they are the same :                  
            if(std.file.getSize(filename) == std.file.getSize(destfilename) )
            {                
                writeln("File '"~destfilename~"' already exists.");        
                return -1;
            }else
            {
                //Try another name
                //Compose a new name
                string ext = std.path.extension(destfilename);
                string nameNoExt = std.path.stripExtension(destfilename);
                //build OCCURRENCES table :
                if( destfilename ! in OCCURRENCES)
                {
                    OCCURRENCES[destfilename ] = 1; //First occurrence
                }else
                {
                    OCCURRENCES[destfilename] ++; // Let's increment..
                }
                import std.conv;                
                destfilename =  nameNoExt~"_"~to!string(OCCURRENCES[destfilename]) ~ ext;
                writeln("New name = ", destfilename );
                //Try with a new name
                return tryCreateLink(filename, destfilename);                
            }

    }else
    {
        //Can Create
        std.file.symlink(filename , destfilename);
        if(std.file.exists(destfilename) ) //link creation success !?
        {
            writeln("'"~ destfilename ~ "' created OK.");  
                return 0;
        }
    }
    return 5;
}//tryCreateLink


string sourceFile="";
string destination="";

void job()
{
        //File f = File(sourceFile,"r");     
        string content = std.file.readText(sourceFile); //2023-11-18 18:59:45 - ReadToEnd
        string [] lines = content.split("\n");
        //writeln(lines);      
        foreach( line ; lines )
        {
            writeln("line=",std.string.strip(line));
            string trimmed = std.string.strip(line);
            if( trimmed.length  )
             {                
                string filename = line;
                string basename = std.path.baseName(line);
                string destfilename =  destination~"/"~basename;
                writeln("symlink("~filename~","~destfilename~"); ");
                //writeln("File Size: ", std.file.getSize(filename)  );
                int res = tryCreateLink(filename, destfilename);                
                writeln("TryCreateLink = ", res);
             }//trimmed line exists
        }
}//job



void main(string [] args)
{

    writeln(APP_NAME);

    if( args.length <=1)
    {

        writeln("Source file ?");
        sourceFile = strip(readln());
    }else
    {
        sourceFile = args[1];        
    }
    writeln("Source file is ", "'"~sourceFile~"'");

    writeln("Destination ?");
    destination = strip(readln());
    if( destination.length<=0) 
    {
        writeln("Destination required");
        exit(0);
    }
    //destination does not exists :     
    if( !(exists(destination) && isDir(destination)) ) //2023-11-18 19:27:15 - Check path existence
    {
        writeln("Create destination path");
        mkdir(destination);  
    }

   // string command = "find /usr/share/hydrogen -iname \"*kick*\" ";
   // writeln("command is = ",command);
    //auto ls = executeShell(command);
    // if (ls.status != 0) 
    // {
    //     writeln("Failed to retrieve file listing");    
    // }
    // else
    // {
    //      string [] lines = ls.output.split("\n");
    // }   

    job();
}//main
