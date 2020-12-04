#!/bin/sh

numb='1313'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 4.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 27 --qp 50 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.4,4.2,0.4,0.9,0.1,3,2,12,0,220,3,27,50,4,2,68,48,5,2000,1:1,hex,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"