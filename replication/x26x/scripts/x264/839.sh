#!/bin/sh

numb='840'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 5 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.4,1.3,0.2,0.3,0.6,0.2,2,1,16,5,260,0,25,50,5,1,60,18,4,2000,-2:-2,hex,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"