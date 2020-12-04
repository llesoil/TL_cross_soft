#!/bin/sh

numb='130'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.0 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 40 --keyint 300 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.1,1.4,2.0,0.6,0.8,0.1,0,1,12,40,300,4,29,30,4,1,61,48,4,1000,-2:-2,hex,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"