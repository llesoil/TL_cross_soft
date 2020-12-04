#!/bin/sh

numb='444'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 10 --keyint 250 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.5,1.2,4.4,0.5,0.7,0.9,1,0,2,10,250,2,28,40,5,1,69,18,6,1000,-2:-2,hex,crop,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"