#!/bin/sh

numb='2509'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 35 --keyint 300 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.2,1.0,2.8,0.6,0.7,0.6,0,0,12,35,300,4,25,50,4,1,62,28,3,1000,-2:-2,hex,show,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"