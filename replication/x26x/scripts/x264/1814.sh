#!/bin/sh

numb='1815'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.2,1.3,2.0,0.3,0.8,0.9,0,1,10,50,230,0,26,40,4,1,65,48,5,1000,-1:-1,hex,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"