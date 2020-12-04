#!/bin/sh

numb='1626'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.2,1.4,0.4,0.8,0.9,3,1,16,50,240,4,26,40,5,4,63,38,3,1000,1:1,hex,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"