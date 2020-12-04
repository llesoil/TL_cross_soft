#!/bin/sh

numb='129'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,0.5,1.3,1.1,5.0,0.5,0.6,0.1,2,0,0,20,210,1,25,30,4,2,62,38,2,2000,1:1,dia,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"