#!/bin/sh

numb='1858'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 45 --keyint 270 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.0,0.8,0.6,0.8,0.6,2,0,10,45,270,2,26,30,4,1,65,18,6,1000,-1:-1,dia,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"