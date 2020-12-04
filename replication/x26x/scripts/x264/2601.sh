#!/bin/sh

numb='2602'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 0 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.1,1.2,4.6,0.2,0.9,0.0,1,0,8,0,210,0,28,40,3,2,65,38,1,2000,-2:-2,hex,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"