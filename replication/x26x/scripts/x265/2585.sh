#!/bin/sh

numb='2586'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 30 --keyint 210 --lookahead-threads 3 --min-keyint 27 --qp 30 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.3,4.4,0.4,0.7,0.5,1,0,0,30,210,3,27,30,5,3,65,38,1,1000,-2:-2,hex,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"