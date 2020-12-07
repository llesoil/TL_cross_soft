#!/bin/sh

numb='116'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 50 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.3,1.0,1.0,0.6,0.7,0.9,0,0,14,50,270,3,25,0,3,3,65,38,5,2000,-2:-2,umh,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"