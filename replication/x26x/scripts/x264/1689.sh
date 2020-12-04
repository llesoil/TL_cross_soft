#!/bin/sh

numb='1690'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 3.0 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,2.5,1.2,1.0,3.0,0.4,0.7,0.3,2,0,8,45,210,3,28,40,5,4,65,28,4,1000,-1:-1,hex,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"