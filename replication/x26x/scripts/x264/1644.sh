#!/bin/sh

numb='1645'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 5 --keyint 240 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.4,0.8,0.4,0.8,0.5,2,2,10,5,240,2,22,40,4,1,65,38,3,1000,-1:-1,umh,crop,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"