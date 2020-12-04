#!/bin/sh

numb='1077'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 45 --keyint 210 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.3,1.1,3.8,0.2,0.7,0.3,1,2,2,45,210,3,26,50,5,4,61,28,3,2000,1:1,umh,crop,veryslow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"