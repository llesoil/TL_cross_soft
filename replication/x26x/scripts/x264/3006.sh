#!/bin/sh

numb='3007'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.6,1.3,0.4,0.4,0.8,0.0,3,1,2,50,240,0,29,30,5,3,63,18,5,1000,-2:-2,hex,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"