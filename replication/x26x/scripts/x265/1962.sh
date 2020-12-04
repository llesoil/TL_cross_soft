#!/bin/sh

numb='1963'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 20 --keyint 270 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.3,1.3,3.4,0.5,0.6,0.2,2,2,2,20,270,1,20,10,5,3,60,28,2,1000,-1:-1,dia,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"