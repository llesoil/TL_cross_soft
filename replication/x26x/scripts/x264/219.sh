#!/bin/sh

numb='220'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 1 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.1,1.4,1.2,0.2,0.9,0.9,1,0,12,10,270,3,26,40,3,1,68,38,4,1000,-2:-2,hex,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"