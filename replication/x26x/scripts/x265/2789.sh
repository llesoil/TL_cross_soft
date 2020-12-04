#!/bin/sh

numb='2790'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 10 --keyint 240 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.1,2.0,0.2,0.8,0.6,1,1,4,10,240,4,30,30,3,2,62,48,6,1000,-1:-1,umh,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"