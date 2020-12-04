#!/bin/sh

numb='2657'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 2 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.0,1.1,1.4,0.4,0.7,0.3,1,1,6,45,260,3,27,10,5,2,61,18,4,1000,-2:-2,umh,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"