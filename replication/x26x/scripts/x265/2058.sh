#!/bin/sh

numb='2059'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.2,1.1,0.2,0.4,0.6,0.1,0,2,4,20,290,1,23,20,3,2,68,18,2,1000,-1:-1,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"