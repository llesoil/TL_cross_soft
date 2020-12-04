#!/bin/sh

numb='2037'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 30 --keyint 250 --lookahead-threads 1 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.5,1.0,1.4,3.2,0.6,0.8,0.9,2,2,6,30,250,1,22,10,5,4,66,48,2,2000,-2:-2,hex,show,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"