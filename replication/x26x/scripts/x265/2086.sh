#!/bin/sh

numb='2087'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 2 --min-keyint 29 --qp 20 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,3.0,1.2,1.3,1.4,0.4,0.8,0.5,2,0,16,45,300,2,29,20,3,0,63,48,1,1000,-1:-1,hex,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"