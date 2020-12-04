#!/bin/sh

numb='547'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 12 --crf 35 --keyint 210 --lookahead-threads 1 --min-keyint 26 --qp 0 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.1,0.6,0.6,0.7,0.8,1,0,12,35,210,1,26,0,3,4,67,38,3,1000,1:1,umh,crop,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"