#!/bin/sh

numb='2945'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 4.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 5 --keyint 210 --lookahead-threads 4 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.4,1.4,4.4,0.6,0.7,0.1,2,1,16,5,210,4,20,10,3,4,69,38,5,2000,-2:-2,hex,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"